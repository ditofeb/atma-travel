<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Pemesanan extends Model
{
    use HasFactory;

    public $timestamps = false;
    protected $table = "pemesanans";
    protected $primaryKey = "id";

    protected $fillable = [
        'id_user',
        'jumlah_tiket',
        'tanggal_pemesanan',
        'status_pemesanan',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user', 'id');
    }

    public function tikets()
    {
        return $this->hasMany(Tiket::class, 'id_pemesanan', 'id');
    }
    
    public function reviewDriver()
    {
        return $this->hasOne(ReviewDriver::class, 'id_pemesanan', 'id');
    }
    
    public function reviewKendaraan()
    {
        return $this->hasOne(ReviewKendaraan::class, 'id_pemesanan', 'id');
    }

    public function pembayaran()
    {
        return $this->hasOne(Pembayaran::class, 'id_pemesanan', 'id');
    }
}
