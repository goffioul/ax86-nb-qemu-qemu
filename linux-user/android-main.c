extern int qemu_main(int argc, char **argv, char **envp);
int main(int argc, char **argv, char **envp) { return qemu_main(argc, argv, envp); }
