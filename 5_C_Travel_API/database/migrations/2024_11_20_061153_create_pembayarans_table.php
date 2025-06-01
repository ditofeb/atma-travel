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
        Schema::create('pembayarans', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('id_pemesanan');
            $table->string('metode_pembayaran');
            $table->decimal('total_biaya', 8, 2);
            $table->string('status');
            $table->dateTime('tanggal_transaksi');

            $table->foreign('id_pemesanan', 'fk_pembayarans_id_pemesanan')
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
        Schema::dropIfExists('pembayarans');
    }
};
