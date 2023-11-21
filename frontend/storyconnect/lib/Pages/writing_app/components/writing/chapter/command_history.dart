import 'dart:collection';

enum CommandType {
  switchChapter,
  updateChapter,
}

class Command {
  final int chapterNum;
  final CommandType commandType;
  const Command({required this.chapterNum, required this.commandType});
}

final class CommandEntry<T extends Command> extends LinkedListEntry<CommandEntry<T>> {
  T value;
  CommandEntry(this.value);
}

class CommandHistory<T extends Command> {
  final LinkedList<CommandEntry<T>> _history = LinkedList<CommandEntry<T>>();
  final _redoStack = <CommandEntry<T>>[];

  CommandHistory();

  bool get canUndo => _history.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void add(T command) {
    _history.add(CommandEntry(command));
    if (_history.length > 100) {
      _history.first.unlink();
    }
    _redoStack.clear();
  }

  Command? undo() {
    final entry = _history.last;
    _redoStack.add(entry);
    _history.last.unlink();
    return entry.value;
  }

  Command redo() {
    final entry = _redoStack.last;
    _history.add(entry);
    _redoStack.removeLast();
    return entry.value;
  }
}
