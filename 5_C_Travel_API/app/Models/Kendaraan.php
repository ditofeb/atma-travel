<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Kendaraan extends Model
{
    use HasFactory;

    public $timestamps = false;
    protected $table = "kendaraans";
    protected $primaryKey = "id";

    protected $fillable = [
        'jenis_kendaraan',
        'nomor_plat',
        'total_rating',
        'kapasitas',
    ];

    public function reviewKendaraans()
    {
        return $this->hasMany(ReviewKendaraan::class, 'id_kendaraan', 'id');
    }

    public function jadwals()
    {
        return $this->hasMany(Jadwal::class, 'id_kendaraan', 'id');
    }
}
