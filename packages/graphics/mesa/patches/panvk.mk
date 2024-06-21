diff --git a/src/panfrost/vulkan/panvk_instance.c b/src/panfrost/vulkan/panvk_instance.c
index c6cb98825098a4cb056446675aa7789d71b8c0ab..23076f9932c4b65d56db9e1969df41ff25d77d18 100644
--- a/src/panfrost/vulkan/panvk_instance.c
+++ b/src/panfrost/vulkan/panvk_instance.c
@@ -38,10 +38,6 @@ static const struct debug_control panvk_debug_options[] = {
    {"no_known_warn", PANVK_DEBUG_NO_KNOWN_WARN},
    {NULL, 0}};
 
-#if defined(VK_USE_PLATFORM_WAYLAND_KHR)
-#define PANVK_USE_WSI_PLATFORM
-#endif
-
 VKAPI_ATTR VkResult VKAPI_CALL
 panvk_EnumerateInstanceVersion(uint32_t *pApiVersion)
 {
diff --git a/src/panfrost/vulkan/panvk_instance.h b/src/panfrost/vulkan/panvk_instance.h
index 550f6dc0a22655f3322597df88dc62b2146b49b6..aafe590b133478769c8c5cebd07fb6d7db5911e7 100644
--- a/src/panfrost/vulkan/panvk_instance.h
+++ b/src/panfrost/vulkan/panvk_instance.h
@@ -23,6 +23,10 @@ enum panvk_debug_flags {
    PANVK_DEBUG_NO_KNOWN_WARN = 1 << 7,
 };
 
+#if defined(VK_USE_PLATFORM_WAYLAND_KHR)
+#define PANVK_USE_WSI_PLATFORM
+#endif
+
 struct panvk_instance {
    struct vk_instance vk;
 
