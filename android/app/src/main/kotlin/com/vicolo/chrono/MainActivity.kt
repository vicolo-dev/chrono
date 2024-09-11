package com.vicolo.chrono

import android.app.Activity
import android.content.Intent
import android.net.Uri
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "com.vicolo.chrono/documents"
    private lateinit var result: MethodChannel.Result

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getDirectoryPath" -> {
                        this.result = result
                        val intent = Intent(this, DirectoryPickerActivity::class.java)
                        startActivityForResult(intent, PICK_DIRECTORY_REQUEST_CODE)
                    }
                    "listDirectories" -> {
                        val uriString = call.argument<String>("uri")!!
                        val uri = Uri.parse(uriString)
                        val directories = listDirectories(uri)
                        result.success(directories)
                    }
                    "listFiles" -> {
                        val uriString = call.argument<String>("uri")!!
                        val uri = Uri.parse(uriString)
                        val files = listFiles(uri)
                        result.success(files)
                    }
                    "getFileChunk" -> {
                        val uriString = call.argument<String>("uri")!!
                        val offset = call.argument<Int>("offset")!!
                        val chunkSize = call.argument<Int>("chunkSize")!!
                        val uri = Uri.parse(uriString)
                        val chunk = readFileChunk(uri, offset, chunkSize)
                        if (chunk != null) {
                            result.success(chunk)
                        } else {
                            result.error("READ_ERROR", "Failed to read file chunk", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PICK_DIRECTORY_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            val pickedDirectoryUri = data?.getStringExtra("getDirectoryUri")
            if (pickedDirectoryUri != null) {
                result.success(pickedDirectoryUri)
            } else {
                result.error("NO_DIRECTORY_URI", "No directory URI found", null)
            }
        }
    }

    private fun listDirectories(uri: Uri): List<String> {
        val directory = DocumentFile.fromTreeUri(this, uri)
        val directories = mutableListOf<String>()

        if (directory != null && directory.isDirectory) {
            for (item in directory.listFiles()) {
                if (item.isDirectory) {
                    directories.add(item.uri.toString())
                }
            }
        }

        return directories
    }

    private fun listFiles(uri: Uri): List<Map<String, Any>> {
        val directory = DocumentFile.fromTreeUri(this, uri)
        val files = mutableListOf<Map<String, Any>>()

        if (directory != null && directory.isDirectory) {
            for (item in directory.listFiles()) {
                if (item.isFile) {
                    val fileInfo: Map<String, Any> = mapOf(
                        "uri" to item.uri.toString(),
                        "name" to (item.name ?: "Unknown"),
                        "size" to item.length(),
                        "modified" to item.lastModified()
                    )
                    files.add(fileInfo)
                }
            }
        }

        return files
    }

    private fun readFileChunk(uri: Uri, offset: Int, chunkSize: Int): ByteArray? {
        return try {
            contentResolver.openInputStream(uri)?.use { inputStream ->
                inputStream.skip(offset.toLong())
                val buffer = ByteArray(chunkSize)
                val bytesRead = inputStream.read(buffer, 0, chunkSize)
                if (bytesRead != -1) {
                    buffer.copyOf(bytesRead)
                } else {
                    null
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    companion object {
        const val PICK_DIRECTORY_REQUEST_CODE = 1
    }
}
