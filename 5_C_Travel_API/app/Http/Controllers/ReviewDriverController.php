<?php

namespace App\Http\Controllers;

use App\Models\Driver;
use App\Models\ReviewDriver;
use App\Models\Pemesanan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Exception;
use Illuminate\Contracts\Support\ValidatedData;

class ReviewDriverController extends Controller
{
    protected $driverController;

    public function __construct(DriverController $driverController)
    {
        $this->driverController = $driverController;
    }

    //Melihat semua review driver
    public function index($driverId)
    {
        try {
            $driver = Driver::find($driverId);
            if (!$driver) {
                return response()->json(['message' => 'Driver tidak ditemukan.'], 401);
            }


            $reviewDriver = DB::table('review_drivers as rd')
                ->join('pemesanans as p', 'rd.id_pemesanan', '=', 'p.id')
                ->join('users as u', 'p.id_user', '=', 'u.id')
                ->where('rd.id_driver', $driverId)
                ->select('rd.id', 'rd.rating', 'rd.komentar', 'rd.id_pemesanan', 'u.username')
                ->get();

            $reviewDriverWithUser = $reviewDriver->map(function ($review) {
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
                'message' => 'Berhasil mengambil data Review Driver',
                'data' => $reviewDriverWithUser,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    //Menyimpan 1 review driver
    public function store(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'id_driver' => 'required',
                'id_pemesanan' => 'required',
                'rating' => 'required',
                'komentar' => 'required',
            ]);

            $driver = Driver::find($validatedData['id_driver']);
            if (!$driver) {
                return response()->json([
                    'status' => false,
                    'message' => 'Driver tidak ditemukan.',
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

            $reviewDriver = ReviewDriver::create([
                'id_driver' => $validatedData['id_driver'],
                'id_pemesanan' => $validatedData['id_pemesanan'],
                'rating' => $validatedData['rating'],
                'komentar' => $validatedData['komentar'],
            ]);

            $this->driverController->updateTotalRating($validatedData['id_driver']);

            return response()->json([
                'status' => true,
                'message' => 'Berhasil menyimpan review data driver baru.',
                'data' => $reviewDriver
            ], 201);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    //Melihat 1 review driver
    public function show($id)
    {
        try {
            $reviewDriver = ReviewDriver::find($id);

            if (!$reviewDriver) {
                return response()->json([
                    'status' => false,
                    'message' => 'Review Driver tidak ditemukan.',
                    'data' => []
                ], 400);
            }

            return response()->json([
                'status' => true,
                'message' => 'Berhasil ambil 1 data review driver',
                'data' => $reviewDriver
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
