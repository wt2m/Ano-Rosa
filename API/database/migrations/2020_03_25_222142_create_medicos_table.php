<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMedicosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('medicos', function (Blueprint $table) {
            $table->id();
            $table->string('nomemed');
            $table->string('fotomed')->nullable();
            $table->string('aboutme')->nullable();
            $table->float('avaliacaototal')->default(0);
            $table->integer('quantavaliacao')->default(0);
            $table->string('cpfmed')->unique();
            $table->string('uf');
            $table->string('cidade');
            $table->string('bairro');
            $table->string('rua');
            $table->float('latitude');
            $table->float('longitude');
            $table->foreignId('empresa_id')->constrained();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('medicos');
    }
}
