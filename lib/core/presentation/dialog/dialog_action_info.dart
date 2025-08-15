class DialogActionInfo<T extends Enum> {
  DialogActionInfo({required this.actionType, required this.actionName, required this.actionStyle});

  final T actionType;
  final String actionName;
  final DialogActionStyle actionStyle;
}

enum DialogActionStyle {
  primary,
  secondary
}
