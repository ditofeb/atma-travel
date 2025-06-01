<?php

namespace App\Http\Controllers;

use App\Models\Tiket;
use App\Models\User;
use App\Models\Pemesanan;
use App\Models\Jadwal;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Exception;

class TiketController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $tiket = Tiket::all();
            return response()->json([
                'status' => true,
                'message' => 'Berhasil mengambil data Tiket',
                'data' => $tiket
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
     * Store a newly created resource in storage.
     */
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

            $request->validate([
                'id_pemesanan' => 'required',
                'id_jadwal' => 'required',
                'kelas' => 'required',
                'kursi' => 'required',
                // 'harga_tiket' => 'required',
            ]);

            $pemesananId = $request->id_pemesanan;
            $pemesanan = Pemesanan::find($pemesananId);
            if (!$pemesanan) {
                return response()->json([
                    'status' => false,
                    'message' => 'Pemesanan tidak ditemukan.',
                    'data' => []
                ], 400);
            }

            $jadwalId = $request->id_jadwal;
            $jadwal = Jadwal::find($jadwalId);
            if (!$jadwal) {
                return response()->json([
                    'status' => false,
                    'message' => 'Jadwal tidak ditemukan.',
                    'data' => []
                ], 400);
            }

            if ($request->kelas == "VIP") {
                $hargaTiket = $jadwal->harga * 1.5;
            } else {
                $hargaTiket = $jadwal->harga;
            }

            $tiket = Tiket::create([
                'id_pemesanan' => $pemesananId,
                'id_jadwal' => $jadwalId,
                'kelas' => $request->kelas,
                'kursi' => $request->kursi,
                'harga_tiket' => $hargaTiket,
            ]);

            return response()->json([
                'status' => true,
                'message' => 'Berhasil menyimpan satu Tiket',
                'data' => $tiket
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
     * Display the specified resource.
     */
    public function show(Tiket $tiket)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Tiket $tiket)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Tiket $tiket)
    {
        //
    }
}
