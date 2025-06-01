<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ReviewKendaraan extends Model
{
    use HasFactory;

    public $timestamps = false;
    protected $table = "review_kendaraans";
    protected $primaryKey = "id";

    protected $fillable = [
        'id_kendaraan',
        'id_pemesanan',
        'rating',
        'komentar',
    ];

    public function kendaraan()
    {
        return $this->belongsTo(Kendaraan::class, 'id_kendaraan', 'id');
    }

    public function pemesanan()
    {
        return $this->belongsTo(Pemesanan::class, 'id_pemesanan', 'id');
    }
}
