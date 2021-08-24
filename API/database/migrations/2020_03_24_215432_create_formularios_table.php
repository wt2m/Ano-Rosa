<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateFormulariosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('formularios', function (Blueprint $table) {
            $table->id();
            $table->text('explicacaoprotocolo');
            $table->string('imagemexplicativa');
            $table->string('pergunta')->nullable();
            $table->string('alternativa1');
            $table->float('indicea1');
            $table->string('alternativa2');
            $table->float('indicea2');
            $table->string('alternativa3')->nullable();
            $table->float('indicea3')->nullable();
            $table->string('alternativa4')->nullable();
            $table->float('indicea4')->nullable();
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
        Schema::dropIfExists('formularios');
    }
}
