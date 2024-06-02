https://ffmpeg.org/doxygen/0.9/mem_8h-source.html


#ifndef AVUTIL_MEM_H
#define AVUTIL_MEM_H

#include "attributes.h"
#include "error.h"
#include "avutil.h"

#if defined(__INTEL_COMPILER) && __INTEL_COMPILER < 1110 || defined(__SUNPRO_C)
    #define DECLARE_ALIGNED(n,t,v)      t __attribute__ ((aligned (n))) v
    #define DECLARE_ASM_CONST(n,t,v)    const t __attribute__ ((aligned (n))) v
#elif defined(__TI_COMPILER_VERSION__)
    #define DECLARE_ALIGNED(n,t,v)                      \
        AV_PRAGMA(DATA_ALIGN(v,n))                      \
        t __attribute__((aligned(n))) v
    #define DECLARE_ASM_CONST(n,t,v)                    \
        AV_PRAGMA(DATA_ALIGN(v,n))                      \
        static const t __attribute__((aligned(n))) v
#elif defined(__GNUC__)
    #define DECLARE_ALIGNED(n,t,v)      t __attribute__ ((aligned (n))) v
    #define DECLARE_ASM_CONST(n,t,v)    static const t av_used __attribute__ ((aligned (n))) v
#elif defined(_MSC_VER)
    #define DECLARE_ALIGNED(n,t,v)      __declspec(align(n)) t v
    #define DECLARE_ASM_CONST(n,t,v)    __declspec(align(n)) static const t v
#else
    #define DECLARE_ALIGNED(n,t,v)      t v
    #define DECLARE_ASM_CONST(n,t,v)    static const t v
#endif

#if AV_GCC_VERSION_AT_LEAST(3,1)
    #define av_malloc_attrib __attribute__((__malloc__))
#else
    #define av_malloc_attrib
#endif

#if AV_GCC_VERSION_AT_LEAST(4,3)
    #define av_alloc_size(n) __attribute__((alloc_size(n)))
#else
    #define av_alloc_size(n)
#endif

void *av_malloc(size_t size) av_malloc_attrib av_alloc_size(1);

void *av_realloc(void *ptr, size_t size) av_alloc_size(2);

void *av_realloc_f(void *ptr, size_t nelem, size_t elsize);

void av_free(void *ptr);

void *av_mallocz(size_t size) av_malloc_attrib av_alloc_size(1);

void *av_calloc(size_t nmemb, size_t size) av_malloc_attrib;

char *av_strdup(const char *s) av_malloc_attrib;

void av_freep(void *ptr);

void av_dynarray_add(void *tab_ptr, int *nb_ptr, void *elem);

static inline int av_size_mult(size_t a, size_t b, size_t *r)
{
    size_t t = a * b;
    /* Hack inspired from glibc: only try the division if nelem and elsize
     * are both greater than sqrt(SIZE_MAX). */
    if ((a | b) >= ((size_t)1 << (sizeof(size_t) * 4)) && a && t / a != b)
        return AVERROR(EINVAL);
    *r = t;
    return 0;
}

#endif /* AVUTIL_MEM_H */