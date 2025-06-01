<?php

namespace App\Http\Controllers;

use App\Models\Pembayaran;
use App\Models\User;
use App\Models\Pemesanan;
use App\Http\Controllers\TiketController;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Exception;

class PembayaranController extends Controller
{
    private $tiketController;
    public function __construct(TiketController $tiketController)
    {
        $this->tiketController = $tiketController;
    }
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $pembayaran = Pembayaran::all();
            return response()->json([
                'status' => true,
                'message' => 'Berhasil mengambil data Pembayaran',
                'data' => $pembayaran
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
            $user  = User::find($userId);

            if (!$user) {
                return response()->json([
                    'status' => false,
                    'message' => 'User tidak ditemukan.',
                    'data' => [],
                ], 400);
            }


            $statusPembayaran = 'Selesai';

            $request->validate([
                'id_pemesanan' => 'required',
                'metode_pembayaran' => 'required',
                'total_biaya' => 'required',
                'status' => 'required',
            ]);

            $pemesananId = $request->id_pemesanan;
            $pemesanan = Pemesanan::find($pemesananId);

            if (!$pemesanan) {
                return response()->json([
                    'status' => false,
                    'message' => 'Pemesanan tidak ditemukan.',
                    'data' => [],
                ]);
            }

            $pembayaran = Pembayaran::create([
                'id_pemesanan' => $pemesananId,
                'metode_pembayaran' => $request->metode_pembayaran,
                'total_biaya' => $request->total_biaya,
                'status' => $statusPembayaran,
                'tanggal_transaksi' => now(),
            ]);

            // $banyakTiket = $pemesanan->jumlah_tiket;

            // for($i=0; $i<$banyakTiket; $i++){
            //     $tiketRequest = new Request([
            //         'id_pemesanan' => $pemesananId,
            //         'id_jadwal' => $pemesanan->id_jadwal,
            //         'kelas' => $pemesanan->kelas,
            //         'kursi' => $i+1,
            //         'harga_tiket' => $pemesanan->harga_tiket,
            //     ]);
            //     $this->tiketController->store($tiketRequest);
            // }

            return response()->json([
                'status' => true,
                'message' => 'Berhasil membuat pembayaran',
                'data' => $pembayaran,
            ], 201);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => [],
            ], 400);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Pembayaran $pembayaran)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Pembayaran $pembayaran)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Pembayaran $pembayaran)
    {
        //
    }
}
