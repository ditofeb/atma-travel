<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\DriverController;
use App\Http\Controllers\PemesananController;
use App\Http\Controllers\ReviewDriverController;
use App\Http\Controllers\KendaraanController;
use App\Http\Controllers\ReviewKendaraanController;
use App\Http\Controllers\JadwalController;
use App\Http\Controllers\TiketController;
use App\Http\Controllers\PembayaranController;
use App\Models\Pembayaran;

Route::post('/user/register', [UserController::class, 'register']);
Route::post('/user/login', [UserController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/user/logout', [UserController::class, 'logout']);
    Route::delete('/user/delete', [UserController::class, 'destroy']);
    Route::put('/user/update', [UserController::class, 'update']);
    Route::post('/user/update/profilepicture', [UserController::class, 'updateProfilePicture']);

    Route::get('/pemesanan/index', [PemesananController::class, 'index']);
    Route::post('/pemesanan/create', [PemesananController::class, 'store']);
    Route::get('/pemesanan/show/{pemesananId}', [PemesananController::class, 'show']);
    Route::post('/pemesanan/selesai/{pemesananId}', [PemesananController::class, 'setStatusSelesai']);
    Route::post('/tiket/create', [TiketController::class, 'store']);
    Route::post('/pembayaran/create', [PembayaranController::class, 'store']);
});

Route::get('/user/index', [UserController::class, 'index']);
Route::get('/user/show/{id}', [UserController::class, 'show']);

Route::get('/driver/index', [DriverController::class, 'index']);
Route::post('/driver/create', [DriverController::class, 'store']);
Route::get('/driver/show/{id}', [DriverController::class, 'show']);
Route::put('/driver/rating/{id}', [DriverController::class, 'updateTotalRating']);

Route::get('/driver/review/index/{driverId}', [ReviewDriverController::class, 'index']);
Route::post('/driver/review/create', [ReviewDriverController::class, 'store']);

Route::get('/kendaraan/index', [KendaraanController::class, 'index']);
Route::post('/kendaraan/create', [KendaraanController::class, 'store']);
Route::get('/kendaraan/show/{id}', [KendaraanController::class, 'show']);
Route::put('/kendaraan/rating/{id}', [KendaraanController::class, 'updateTotalRating']);

Route::get('/kendaraan/review/index/{kendaraanId}', [ReviewKendaraanController::class, 'index']);
Route::post('/kendaraan/review/create', [ReviewKendaraanController::class, 'store']);




Route::get('/jadwal/index', [JadwalController::class, 'index']);
Route::post('/jadwal/create', [JadwalController::class, 'store']);
