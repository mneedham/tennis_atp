import psutil

def memory_usage():
    return psutil.Process().memory_info().rss / (1024 * 1024)
