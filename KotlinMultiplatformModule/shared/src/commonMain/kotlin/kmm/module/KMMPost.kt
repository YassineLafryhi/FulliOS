package kmm.module

import kotlinx.serialization.Serializable

@Serializable
data class KMMPost(
    val userId: Int,
    val id: Int,
    val title: String,
    val body: String
)
