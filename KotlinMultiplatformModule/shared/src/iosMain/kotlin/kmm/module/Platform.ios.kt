package kmm.module

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class IOSPlatform {
    fun fetchPosts(success: (List<KMMPost>) -> Unit, failure: (Throwable) -> Unit) {
        val postService = PostService()
        GlobalScope.launch(Dispatchers.Main) {
            try {
                val posts = postService.getPosts()
                success(posts)
            } catch (e: Exception) {
                failure(e)
            }
        }
    }
}
