<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ReviewDriver extends Model
{
    use HasFactory;

    public $timestamps = false;
    protected $table = "review_drivers";
    protected $primaryKey = "id";

    protected $fillable = [
        'id_driver',
        'id_pemesanan',
        'rating',
        'komentar',
    ];

    public function driver()
    {
        return $this->belongsTo(Driver::class, 'id_driver', 'id');
    }

    public function pemesanan()
    {
        return $this->belongsTo(Pemesanan::class, 'id_pemesanan', 'id');
    }
}
