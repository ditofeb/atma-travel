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
        Schema::create('jadwals', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('id_driver');
            $table->unsignedBigInteger('id_kendaraan');
            $table->string('titik_keberangkatan');
            $table->string('titik_kedatangan');
            $table->dateTime('waktu_keberangkatan');
            $table->dateTime('waktu_kedatangan');
            $table->decimal('harga', 8, 2);

            $table->foreign('id_driver', 'fk_jadwals_id_driver')
                ->references('id')->on('drivers')
                ->onDelete('cascade')
                ->onUpdate('cascade');

            $table->foreign('id_kendaraan', 'fk_jadwals_id_kendaraan')
                ->references('id')->on('kendaraans')
                ->onDelete('cascade')
                ->onUpdate('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('jadwals');
    }
};
