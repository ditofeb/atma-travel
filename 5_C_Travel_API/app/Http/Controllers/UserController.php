<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use Exception;
use App\Models\User;
use Illuminate\Support\Facades\Storage;

use function PHPUnit\Framework\isEmpty;

class UserController extends Controller
{
    public function register(Request $request)
    {
        try {
            $request->validate([
                'username' => 'required|string|max:255|unique:users',
                'email' => 'required|string|email|max:255|unique:users',
                'password' => 'required|string|min:5',
                'nomor_telp' => 'required'
            ]);

            $user = User::create([
                'username' => $request->username,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'nomor_telp' => $request->nomor_telp,
            ]);

            return response()->json([
                'status' => true,
                'message' => 'User registered successfully',
                'data' => $user
            ], 201);
        } catch (ValidationException $e) {
            $error = '';

            if ($e->errors()['username'] ?? false) {
                $error = 'Username sudah digunakan.';
            } else if ($e->errors()['email'] ?? false) {
                $error = 'Email sudah terdaftar.';
            }

            return response()->json([
                'status' => false,
                'message' => $error,
                'data' => []
            ], 422);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    public function login(Request $request)
    {
        try {
            $request->validate([
                'username' => 'required|string',
                'password' => 'required|string',
            ]);

            $user = User::where('username', $request->username)->first();

            if (!$user) {
                return response()->json(['message' => 'Username belum terdaftar. Periksa kembali atau buat akun baru.'], 401);
            } else if (!Hash::check($request->password, $user->password)) {
                return response()->json(['message' => 'Invalid credentials'], 401);
            }

            $token = $user->createToken('Personal Access Token')->plainTextToken;

            return response()->json([
                'status' => true,
                'message' => 'Berhasil login',
                'data' => $user,
                'token' => $token
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    public function logout(Request $request)
    {
        try {
            if (Auth::check()) {
                $userId = Auth::id();
                $user = User::find($userId);
                $user->tokens()->delete();
                return response()->json([
                    'status' => true,
                    'message' => 'Berhasil logout',
                ], 200);
            }

            return response()->json([
                'status' => false,
                'message' => 'Tidak ada User yang sedang login'
            ], 401);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    public function index()
    {
        try {
            $users = User::all();

            if ($users->isEmpty()) {
                return response()->json(['message' => 'List User kosong atau tidak ditemukan.'], 401);
            }

            foreach ($users as $user) {
                if ($user->image) {
                    $hostingDomain = 'https://moccasin-sandpiper-499242.hostingersite.com'; 
                    $user->image_url = $hostingDomain . '/storage/app/public/profile_pictures/' . $user->image;
                } else {
                    $user->image_url = null;
                }
            }

            return response()->json([
                'status' => true,
                'message' => 'Berhasil mencari semua User.',
                'data' => $users,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        try {
            $user = User::find($id);

            if (!$user) {
                return response()->json(['message' => 'Username tidak ditemukan.'], 401);
            }

            if ($user->image) {
                $hostingDomain = 'https://moccasin-sandpiper-499242.hostingersite.com'; 
                $user->image_url = $hostingDomain . '/storage/app/public/profile_pictures/' . $user->image;
            } else {
                $user->image_url = null;
            }

            return response()->json([
                'status' => true,
                'message' => 'Berhasil mencari User.',
                'data' => $user,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request)
    {
        try {
            $id = Auth::id();
            $user = User::find($id);
            if (!$user) {
                return response()->json(['message' => 'Username tidak ditemukan.'], 401);
            }

            if ($request->has('password') && !empty($request->password)) {
                $request->merge(['password' => Hash::make($request->password)]);
            } else {
                $request->merge(['password' => $user->password]);
            }

            $user->update($request->all());

            return response()->json([
                'status' => true,
                'message' => 'Update User berhasil.',
                'data' => $user,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request)
    {
        try {
            $userId = Auth::id();
            $user = User::find($userId);

            if (!$user) {
                return response()->json([
                    'status' => false,
                    'message' => 'User tidak ditemukan'
                ], 403);
            }

            if (Auth::check()) {
                $request->user()->currentAccessToken()->delete();

                if ($user->image) {
                    Storage::disk('public')->delete("profile_pictures/$user->image");
                }
                $user->delete();

                return response()->json([
                    'status' => true,
                    'message' => 'Berhasil delete akun',
                ], 200);
            }

            return response()->json([
                'status' => false,
                'message' => 'Tidak ada User yang sedang login'
            ], 401);
        } catch (Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }

    public function updateProfilePicture(Request $request)
    {
        try {
            $userId = Auth::id();
            $user = User::find($userId);
            if (!$user) {
                return response()->json([
                    'status' => false,
                    'message' => 'User tidak ditemukan'
                ], 403);
            }

            $request->validate([
                'image' => 'required|image|mimes:jpeg,png,jpg,svg|max:2048',
            ]);

            if ($request->hasFile('image')) {

                //Delete file gambar yang lama
                if ($user->image) {
                    Storage::disk('public')->delete("profile_pictures/$user->image");
                }

                $image = $request->file('image');

                $imageName = time() . '_' . $image->getClientOriginalName();

                $image->storeAs('profile_pictures/', $imageName, 'public');

                $user->image = $imageName;
                $user->save();

                $hostingDomain = 'https://moccasin-sandpiper-499242.hostingersite.com'; 
                $user->image_url = $hostingDomain . '/storage/app/public/profile_pictures/' . $user->image;

                return response()->json([
                    'status' => true,
                    'message' => 'Berhasil update profile picture user.',
                    'data' => $user
                ], 200);
            }

            return response()->json(['message' => 'File gambar tidak ditemukan.'], 400);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
                'data' => []
            ], 400);
        }
    }
}
