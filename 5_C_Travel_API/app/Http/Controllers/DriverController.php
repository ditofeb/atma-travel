<?php

namespace App\Http\Controllers;

use App\Models\Driver;
use App\Models\ReviewDriver;
use Illuminate\Http\Request;
use Exception;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class DriverController extends Controller
{
    //Melihat semua driver
    public function index()
    {
        try {
            $drivers = Driver::all();
            $currentDate = Carbon::now();
            $months = [];
            $allDriversWithRatings = [];

            for ($i = 4; $i >= 0; $i--) {
                $months[] = $currentDate->copy()->subMonths($i)->startOfMonth();
            }

            foreach ($drivers as $driver) {
                $monthlyRatings = [];

                foreach ($months as $monthStart) {
                    $reviews = DB::table('review_drivers as rd')
                        ->join('pemesanans as p', 'rd.id_pemesanan', '=', 'p.id')
                        ->where('rd.id_driver', $driver->id)
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

                $allDriversWithRatings[] = [
                    'id' => $driver->id,
                    'nama' => $driver->nama,
                    'tanggal_lahir' => $driver->tanggal_lahir,
                    'nomor_telepon' => $driver->nomor_telepon,
                    'total_rating' => $driver->total_rating,
                    'monthly_rating' => $monthlyRatings,
                ];
            }

            return response()->json([
                'status' => true,
                'message' => 'Berhasil mengambil data Driver dan rating bulanan',
                'data' => $allDriversWithRatings
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    //Menyimpan 1 driver
    public function store(Request $request)
    {
        try {
            $driver = Driver::create($request->all());

            return response()->json([
                'status' => true,
                'message' => 'Berhasil menyimpan data Driver baru.',
                'data' => $driver
            ], 201);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    //Melihat 1 driver
    public function show($id)
    {
        try {
            $driver = Driver::find($id);

            if (!$driver) {
                return response()->json([
                    'status' => false,
                    'message' => 'Driver tidak ditemukan.',
                    'data' => []
                ], 400);
            }

            return response()->json([
                'status' => true,
                'message' => 'Berhasil mengambil 1 data driver',
                'data' => $driver
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    //Update rating rata-rata seorang driver
    public function updateTotalRating($id)
    {
        try {
            $averageRating = ReviewDriver::join('drivers', 'review_drivers.id_driver', '=', 'drivers.id')
                ->where('drivers.id', $id)
                ->avg('review_drivers.rating');

            $driver = Driver::find($id);

            if (!$driver) {
                return response()->json(['message' => 'Driver tidak ditemukan.'], 404);
            }

            $driver->total_rating = $averageRating;
            $driver->save();

            return response()->json([
                'status' => true,
                'message' => 'Driver total rating updated successfully',
                'data' => $driver
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    //Apakah diperlukan??
    public function destroy(Driver $driver)
    {
        //
    }
}
