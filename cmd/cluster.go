package cmd

import (
	"flag"
	"fmt"
	"github.com/spf13/cobra"
	"io/fs"
	"io/ioutil"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/homedir"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func applyYamls() {

	var kubeconfig *string

	if home := homedir.HomeDir(); home != "" {
		kubeconfig = flag.String("kubeconfig", filepath.Join(home, ".kube", "config"), "(optional) absolute path to the kubeconfig file")
	} else {
		kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
	}
	flag.Parse()
	config, err := clientcmd.BuildConfigFromFlags("", *kubeconfig)
	if err != nil {
		panic(err)
	}
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err)
	}
}

var name string

func init() {
	rootCmd.AddCommand(createCmd)
	createCmd.AddCommand(clusterCmd)
	clusterCmd.PersistentFlags().StringVarP(&name, "name", "n", "demo-0", "This is the name of your cluster")
}

func findScriptsPath(dir string) []fs.FileInfo {
	dirOut, err := ioutil.ReadDir(dir)
	if err != nil {
		panic(err)
	}

	return dirOut

}

func findCreateClusterScript() string {
	directory := "./scripts/argocd"
	scripts := findScriptsPath("./scripts/argocd")
	var clusterCreationScript string
	for _, file := range scripts {
		if strings.Contains(file.Name(), "create-kind-cluster") {
			clusterCreationScript = directory + "/" + file.Name()
		}

	}
	return clusterCreationScript

}

var createCmd = &cobra.Command{
	Use:   "create",
	Short: "Create any resource",
	//Run: func(cmd *cobra.Command, args []string) {
	//	script := findCreateClusterScript()
	//	fmt.Println(script + " " + name)
}

var clusterCmd = &cobra.Command{
	Use:   "cluster",
	Short: "Create Cluster",
	Run: func(cmd *cobra.Command, args []string) {

		script := findCreateClusterScript()
		fmt.Println(script + " " + name)
		exe := exec.Command(script, name)
		exe.Stdout = os.Stdout
		exe.Stderr = os.Stderr
		err := exe.Run()
		if err != nil {
			fmt.Println(err)
		}

	},
}
