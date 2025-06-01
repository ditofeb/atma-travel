<?php

namespace App\Http\Controllers;

use App\Models\ReviewKendaraan;
use App\Models\Kendaraan;
use Illuminate\Http\Request;
use Exception;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class KendaraanController extends Controller
{
    /**
     * Menampilkan data Kendaraan
     */
    public function index()
    {
        try {
            $kendaraans = Kendaraan::all();
            $currentDate = Carbon::now();
            $months = [];
            $allKendaraansWithRatings = [];

            for ($i = 4; $i >= 0; $i--) {
                $months[] = $currentDate->copy()->subMonths($i)->startOfMonth();
            }

            foreach ($kendaraans as $kendaraan) {
                $monthlyRatings = [];

                foreach ($months as $monthStart) {
                    $reviews = DB::table('review_kendaraans as rd')
                        ->join('pemesanans as p', 'rd.id_pemesanan', '=', 'p.id')
                        ->where('rd.id_kendaraan', $kendaraan->id)
                        ->whereBetween('p.tanggal_pemesanan', [
                            $monthStart->toDateString(),
                            $monthStart->copy()->endOfMonth()->toDateString()
                        ])
                        ->select('rd.rating')
                        ->get();

                    if ($reviews->count() > 0) {
                        $averageRating = $reviews->avg('rating');
                    } else {
                        $averageRating = 0;
                    }

                    $monthlyRatings[] = $averageRating;
                }

                $allKendaraansWithRatings[] = [
                    'id' => $kendaraan->id,
                    'jenis_kendaraan' => $kendaraan->jenis_kendaraan,
                    'nomor_plat' => $kendaraan->nomor_plat,
                    'total_rating' => $kendaraan->total_rating,
                    'kapasitas' => $kendaraan->kapasitas,
                    'monthly_rating' => $monthlyRatings,
                ];
            }

            return response()->json([
                'status' => true,
                'message' => 'Berhasil mengambil data kendaraan dan rating bulanan',
                'data' => $allKendaraansWithRatings
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    /**
     * Menyimpan data kendaraan
     */
    public function store(Request $request)
    {
        try {
            $kendaraan = Kendaraan::create($request->all());

            return response()->json([
                'status' => true,
                'message' => 'Berhasil menyimpan data Kendaraan baru.',
                'data' => $kendaraan
            ], 201);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    /**
     * Menampilkan 1 data Kendaraan
     */
    public function show($id)
    {
        try {
            $kendaraan = Kendaraan::find($id);

            if (!$kendaraan) {
                return response()->json([
                    'status' => false,
                    'message' => 'Kendaraan tidak ditemukan',
                    'data' => []
                ], 400);
            }

            return response()->json([
                'status' => true,
                'message' => 'Berhasil mengambil 1 data driver',
                'data' => $kendaraan
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    /**
     * Update rating rata - rata 1 kendaraan
     */
    public function updateTotalRating($id)
    {
        try {
            $averageRating = ReviewKendaraan::join('kendaraans', 'review_kendaraans.id_kendaraan', '=', 'kendaraans.id')
                ->where('kendaraans.id', $id)
                ->avg('review_kendaraans.rating');

            $kendaraan = Kendaraan::find($id);

            if (!$kendaraan) {
                return response()->json(['message' => 'Kendaraan tidak ditemukan.'], 404);
            }

            $kendaraan->total_rating = $averageRating;
            $kendaraan->save();

            return response()->json([
                'status' => true,
                'message' => 'Kendaraan total rating updated successfully',
                'data' => $kendaraan
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Kendaraan $kendaraan)
    {
        //
    }
}
