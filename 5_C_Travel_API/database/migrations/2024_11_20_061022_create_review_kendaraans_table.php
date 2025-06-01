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
        Schema::create('review_kendaraans', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('id_kendaraan');
            $table->unsignedBigInteger('id_pemesanan');
            $table->integer('rating');
            $table->string('komentar');

            $table->foreign('id_kendaraan', 'fk_review_kendaraans_id_kendaraan')
                ->references('id')->on('kendaraans')
                ->onDelete('cascade')
                ->onUpdate('cascade');

            $table->foreign('id_pemesanan', 'fk_review_kendaraans_id_pemesanan')
                ->references('id')->on('pemesanans')
                ->onDelete('cascade')
                ->onUpdate('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('review_kendaraans');
    }
};
