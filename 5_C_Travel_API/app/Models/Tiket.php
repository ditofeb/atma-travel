<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Laravel\Sanctum\HasApiTokens;

class Tiket extends Model
{
    use HasFactory, HasApiTokens;

    public $timestamps = false;
    public $table = "tikets";
    public $primaryKey = "id";

    protected $fillable = [
        'id_pemesanan',
        'id_jadwal',
        'kelas',
        'kursi',
        'harga_tiket',
    ];

    public function jadwal()
    {
        return $this->belongsTo(Jadwal::class, 'id_jadwal');
    }

    public function pemesanan()
    {
        return $this->belongsTo(Pemesanan::class, 'id_pemesanan');
    }
}
