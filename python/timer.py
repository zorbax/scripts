import time
from functools import reduce


class TimeKeeper:
    def __init__(self):
        self.start_time = time.time()
        self.last_logtime = self.start_time

    def start_timer(self):
        """Restart the timer"""
        self.start_time = time.time()
        self.last_logtime = self.start_time

    def get_timestamp(self):
        """Make a time stamp"""
        now = time.time()
        ret_str = "{ THIS: %s || TOTAL: %s }" % (
            self.seconds2str(now - self.last_logtime),
            self.seconds2str(now - self.start_time),
        )
        self.last_logtime = now
        return ret_str

    @staticmethod
    def seconds2str(t):
        rediv = lambda ll, b: list(divmod(ll[0], b)) + ll[1:]
        return "%d:%02d:%02d.%03d" % tuple(reduce(rediv, [[t * 1000], 1000, 60, 60]))
