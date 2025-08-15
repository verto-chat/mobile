typedef Message = ({
  String text,
  bool isError,
});

const successMessage = (text: "Saved, please restart the app", isError: false);

const errorMessage = (text: "Failed to save, please try again", isError: true);
