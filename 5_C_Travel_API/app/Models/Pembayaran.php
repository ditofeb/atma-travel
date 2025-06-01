<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Pembayaran extends Model
{
    use HasFactory;

    public $timestamps = false;
    protected $table = "pembayarans";
    protected $primaryKey = "id";

    protected $fillable = [
        'id_pemesanan',
        'metode_pembayaran',
        'total_biaya',
        'status',
        'tanggal_transaksi',
    ];

    public function pemesanan()
    {
        return $this->belongsTo(Pemesanan::class, 'id_pemesanan', 'id');
    }
}
