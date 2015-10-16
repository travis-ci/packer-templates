(defun flowers ()
  (goto-char (point-min))
  (replace-regexp "Butterblume" "Sonnenblume")
  (save-buffer))
