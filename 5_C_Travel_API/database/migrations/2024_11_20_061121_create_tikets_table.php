<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('tikets', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('id_pemesanan');
            $table->unsignedBigInteger('id_jadwal');
            $table->string('kelas');
            $table->decimal('harga_tiket', 8, 2);
            $table->string('kursi');

            $table->foreign('id_pemesanan', 'fk_tikets_id_pemesanan')
                ->references('id')->on('pemesanans')
                ->onDelete('cascade')
                ->onUpdate('cascade');

            $table->foreign('id_jadwal', 'fk_tikets_id_jadwal')
                ->references('id')->on('jadwals')
                ->onDelete('cascade')
                ->onUpdate('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tikets');
    }
};
