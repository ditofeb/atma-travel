<?php

namespace App\Http\Controllers;

use App\Models\Pemesanan;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Exception;

class PemesananController extends Controller
{
    //list pemesanan untuk halaman history
    public function index(Request $request)
    {
        try {
            $userId = Auth::id();
            $user = User::find($userId);
            if (!$user) {
                return response()->json([
                    'status' => false,
                    'message' => 'User tidak ditemukan.',
                    'data' => []
                ], 400);
            }

            // Mengambil seluruh data dari relasi yang ada
            $pemesanans = Pemesanan::with([
                'tikets.jadwal.driver',
                'tikets.jadwal.kendaraan',
                'reviewDriver'
            ])
                ->where('id_user', $userId)
                ->get();

            return response()->json([
                'status' => true,
                'message' => 'Berhasil mengambil semua data Pemesanan.',
                'data' => $pemesanans
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    //Membuat Pemesanan
    public function store(Request $request)
    {
        try {
            $userId = Auth::id();
            $user = User::find($userId);
            if (!$user) {
                return response()->json([
                    'status' => false,
                    'message' => 'User tidak ditemukan.',
                    'data' => []
                ], 400);
            }

            $statusPemesanan = 'Ongoing';

            $request->validate([
                'jumlah_tiket' => 'required',
                'tanggal_pemesanan' => 'required',
            ]);

            $pemesanan = Pemesanan::create([
                'id_user' => $userId,
                'jumlah_tiket' => $request->jumlah_tiket,
                'tanggal_pemesanan' => $request->tanggal_pemesanan,
                'status_pemesanan' => $statusPemesanan,
            ]);

            return response()->json([
                'status' => true,
                'message' => 'Berhasil menyimpan data Pemesanan',
                'data' => $pemesanan
            ], 201);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    //untuk halaman detail pemesanan/tripsummaryscreen
    public function show($pemesananId)
    {
        try {

            $pemesanan = Pemesanan::with([
                'tikets.jadwal.driver',
                'tikets.jadwal.kendaraan',
                'reviewDriver'
            ])
                ->where('id', $pemesananId)
                ->first();

            if (!$pemesanan) {
                return response()->json([
                    'status' => false,
                    'message' => 'Pemesanan tidak ditemukan.',
                    'data' => []
                ], 404);
            }

            return response()->json([
                'status' => true,
                'message' => 'Detail satu pemesanan berhasil diambil.',
                'data' => $pemesanan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    public function setStatusSelesai($pemesananId)
    {
        try {
            $pemesanan = Pemesanan::find($pemesananId);

            if (!$pemesanan) {
                return response()->json(['Message' => 'Pemesanan tidak ditemukan']);
            }

            $pemesanan->status_pemesanan = 'Selesai';
            $pemesanan->save();

            return response()->json([
                'status' => true,
                'message' => 'Status Pemesanan berhasil di update',
                'data' => $pemesanan
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
