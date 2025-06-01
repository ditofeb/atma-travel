<?php

namespace App\Http\Controllers;

use App\Models\Jadwal;
use Illuminate\Http\Request;
use Exception;

class JadwalController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $jadwal = Jadwal::with(['driver', 'kendaraan'])
                ->get()
                ->map(function ($item) {
                    $vipSeatsBooked = $item->tikets->where('kelas', 'VIP')->count();
                    $regularSeatsBooked = $item->tikets->where('kelas', 'Reguler')->count();

                    $kapasitasReguler = $item->kendaraan->kapasitas - 5;

                    $item->sisaVIP = max(0, 5 - $vipSeatsBooked);
                    $item->sisaReguler = max(0, $kapasitasReguler - $regularSeatsBooked);

                    return $item;
                });

            return response()->json([
                'status' => true,
                'message' => 'Berhasil mengambil data jadwal',
                'data' => $jadwal
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    //Membuat jadwal baru
    public function store(Request $request)
    {
        //tgl, harga per tiket, awal akhir(lokasi & waktu), nama driver, nama kendaraan
        try {
            $request->validate([
                'titik_keberangkatan' => 'required',
                'titik_kedatangan' => 'required',
                'waktu_keberangkatan' => 'required',
                'waktu_kedatangan' => 'required',
                'id_driver' => 'required',
                'id_kendaraan' => 'required',
                'harga' => 'required',
            ]);

            $jadwal = Jadwal::create([
                'titik_keberangkatan' => $request->titik_keberangkatan,
                'titik_kedatangan' => $request->titik_kedatangan,
                'waktu_keberangkatan' => $request->waktu_keberangkatan,
                'waktu_kedatangan' => $request->waktu_kedatangan,
                'id_driver' => $request->id_driver,
                'id_kendaraan' => $request->id_kendaraan,
                'harga' => $request->harga,
            ]);

            return response()->json([
                'status' => true,
                'message' => 'Berhasil menyimpan data Jadwal baru.',
                'data' => $jadwal
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
    public function show($id)
    {
        try {
            $jadwal = Jadwal::find($id);

            if (!$jadwal) {
                return response()->json([
                    'status' => false,
                    'message' => 'jadwal tidak ditemukan.',
                    'data' => []
                ], 400);
            }

            return response()->json([
                'status' => true,
                'message' => 'Berhasil mengambil 1 data jadwal',
                'data' => $jadwal
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
