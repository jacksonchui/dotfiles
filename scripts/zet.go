package main

import (
  "bufio"
  "fmt"
  "os"
  "os/exec"
  "strings"
  "time"
)

// prompt user for filename
func getFilename() string {
  fmt.Print("Enter a filename: ")
  filename, err := bufio.NewReader(os.Stdin).ReadString('\n')
  if err != nil {
    handleError("reading input", err)
  }
  return strings.TrimSpace(filename)
}

func getTemplateDefault(filename string) string {
  timestamp := time.Now().Format("20060102150405")
  return fmt.Sprintf(
    "---\nid: %s\naliases:\ntags:\n---\n\n# %s\n\n\n## Notes",
    timestamp,
    filename,
  )
}

// Creates file path, writes template to it, and returns path
func createAndWriteFile(dir string, filename string) string {
  filePath := fmt.Sprintf("%s/%s.md", dir, filename)
  file, err := os.Create(filePath)
  handleError("creating file", err)
  defer file.Close()

  content := getTemplateDefault(filename)
  _, err = file.WriteString(content)
  handleError("writing to file", err)

  return filePath
}

func runNvim(filePath string) error {
  fmt.Println("Opening in nvim", filePath)
  cmd := exec.Command("nvim", "-c" , ":set wrap", filePath)
  cmd.Stdout = os.Stdout
  cmd.Stderr = os.Stderr
  return cmd.Run()
}

func handleError(action string, err error) {
  if err == nil {
    return
  }
  fmt.Printf("Error %s: %v\n", action, err)
  os.Exit(1) // exiting for critical errors
}

const ZET_INBOX = "ZET_INBOX_DIR"

func main() {
  filename := ""
  if len(os.Args) > 2 {
    fmt.Println("Usage: zet [filename - no md ext]")
    os.Exit(1)
  } else if len (os.Args) == 2{
    filename = os.Args[1]
  } else {
    filename = getFilename()
  }

  cur_dir := os.Getenv(ZET_INBOX)
  if cur_dir == "" {
    handleError("fetching env var not set", fmt.Errorf(ZET_INBOX))
  }

  filePath := createAndWriteFile(cur_dir, filename)
  err := runNvim(filePath)
  handleError("running nvim", err)
}
