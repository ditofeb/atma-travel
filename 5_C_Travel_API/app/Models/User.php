<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Support\Facades\Storage;

class User extends Authenticatable
{
    use HasFactory, HasApiTokens;

    public $timestamps = false;
    protected $table = "users";
    protected $primaryKey = "id";

    protected $fillable = [
        'username',
        'email',
        'password',
        'nomor_telp',
        'image',
    ];

    public function pemesanans()
    {
        return $this->hasMany(Pemesanan::class, 'id_user', 'id');
    }
}
