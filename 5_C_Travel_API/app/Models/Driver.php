<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Driver extends Model
{
    use HasFactory;
    
    public $timestamps = false;
    protected $table = "drivers";
    protected $primaryKey = "id";

    protected $fillable = [
        'nama',
        'tanggal_lahir',
        'nomor_telepon',
        'total_rating',
    ];

    public function reviewDrivers()
    {
        return $this->hasMany(ReviewDriver::class, 'id_driver', 'id');
    }

    public function jadwals()
    {
        return $this->hasMany(Jadwal::class, 'id_driver', 'id');
    }
}
