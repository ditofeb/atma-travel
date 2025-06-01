<?php

namespace App\Http\Controllers;

use App\Models\Kendaraan;
use App\Models\Pemesanan;
use App\Models\ReviewKendaraan;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Exception;

class ReviewKendaraanController extends Controller
{
    protected $kendaraanController;

    public function __construct(KendaraanController $kendaraanController)
    {
        $this->kendaraanController = $kendaraanController;
    }
    /**
     * Melihat semua review kendaraan
     */
    public function index($kendaraanId)
    {
        try {
            $kendaraan = Kendaraan::find($kendaraanId);
            if (!$kendaraan) {
                return response()->json(['message' => 'Kendaraan tidak ditemukan.'], 401);
            }


            $reviewKendaraan = DB::table('review_kendaraans as rk')
                ->join('pemesanans as p', 'rk.id_pemesanan', '=', 'p.id')
                ->join('users as u', 'p.id_user', '=', 'u.id')
                ->where('rk.id_kendaraan', $kendaraanId)
                ->select('rk.id', 'rk.rating', 'rk.komentar', 'rk.id_pemesanan', 'u.username')
                ->get();

            $reviewKendaraanWithUser = $reviewKendaraan->map(function ($review) {
                return [
                    'id' => $review->id,
                    'id_pemesanan' => $review->id_pemesanan,
                    'rating' => $review->rating,
                    'komentar' => $review->komentar,
                    'username' => $review->username,
                ];
            });

            return response()->json([
                'status' => true,
                'message' => 'Berhasil mengambil data Review Kendaraan',
                'data' => $reviewKendaraanWithUser
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => [],
            ], 400);
        }
    }

    /**
     * Menyimpan 1 review kendaraan
     */
    public function store(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'id_kendaraan' => 'required',
                'id_pemesanan' => 'required',
                'rating' => 'required',
                'komentar' => 'required',
            ]);

            $kendaraan = Kendaraan::find($validatedData['id_kendaraan']);
            if (!$kendaraan) {
                return response()->json([
                    'status' => false,
                    'message' => 'Kendaraan tidak ditemukan.',
                    'data' => []
                ], 400);
            }

            $pemesanan = Pemesanan::find($validatedData['id_pemesanan']);
            if (!$pemesanan) {
                return response()->json([
                    'status' => false,
                    'message' => 'Pemesanan tidak ditemukan.',
                    'data' => []
                ], 400);
            }

            $reviewKendaraan = ReviewKendaraan::create([
                'id_kendaraan' => $validatedData['id_kendaraan'],
                'id_pemesanan' => $validatedData['id_pemesanan'],
                'rating' => $validatedData['rating'],
                'komentar' => $validatedData['komentar'],
            ]);

            $this->kendaraanController->updateTotalRating($validatedData['id_kendaraan']);

            return response()->json([
                'status' => true,
                'message' => 'Berhasil menyimpan data review kendaraan baru.',
                'data' => $reviewKendaraan
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
     *Menampilkan 1 review kendaraan
     */
    public function show($id)
    {
        try {
            $reviewKendaraan = ReviewKendaraan::find($id);

            if (!$reviewKendaraan) {
                return response()->json([
                    'status' => false,
                    'message' => 'Review Kendaraan tidak ditemukan.',
                    'data' => []
                ], 400);
            }

            return response()->json([
                'status' => true,
                'message' => 'Berhasil ambil 1 data review kendaraan',
                'data' => $reviewKendaraan
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }
}
