<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Jadwal extends Model
{
    use HasFactory;

    public $timestamps = false;
    protected $table = "jadwals";
    protected $primaryKey = "id";

    protected $fillable = [
        'titik_keberangkatan',
        'titik_kedatangan',
        'waktu_keberangkatan',
        'waktu_kedatangan',
        'id_driver',
        'id_kendaraan',
        'harga'
    ];

    public function driver()
    {
        return $this->belongsTo(Driver::class, 'id_driver', 'id');
    }

    public function kendaraan()
    {
        return $this->belongsTo(Kendaraan::class, 'id_kendaraan', 'id');
    }

    public function tikets()
    {
        return $this->hasMany(Tiket::class, 'id_jadwal', 'id');
    }
}
