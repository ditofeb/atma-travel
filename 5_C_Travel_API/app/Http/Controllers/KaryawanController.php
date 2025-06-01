<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Karyawan;
class KaryawanController extends Controller
{
    
    public function index(){
        $karyawan = Karyawan::all();
        return view('karyawan.index', compact('karyawan'));
    }

    public function create(){
        return view('karyawan.create');
    }

    public function store(Request $request){
        $request->validate([
            'username' => 'required',
            'tanggal_lahir' => 'required',
            'umur' => 'required'
        ]);

        Karyawan::create($request->all());
        return redirect()->route('karyawan.index')->with('success', 'Karyawan berhasil ditambahkan');
    }
}
