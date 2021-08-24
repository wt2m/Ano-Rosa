<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateInformacaosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('informacaos', function (Blueprint $table) {
            $table->id();
            $table->string('tituloinfo');
            $table->string('url')->nullable();
            $table->string('subtituloinfo');
            $table->string('imageminfo');
            $table->longText('textoinfo');
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
        Schema::dropIfExists('informacaos');
    }
}
