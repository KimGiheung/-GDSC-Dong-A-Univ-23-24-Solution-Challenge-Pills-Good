class PillName:
    def __init__(self, index, accuracy):
        self.index = index
        self.accuracy = accuracy
    def __repr__(self):
        return repr((self.index, self.accuracy))