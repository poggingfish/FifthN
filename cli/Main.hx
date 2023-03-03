class Main{
    public static function Usage(){
        Sys.println("Usage: fn <file>");
    }
    public static function main(){
        if (Sys.args().length != 1){
            Usage();
            Sys.exit(1);
        }
        Sys.println("Preprocessing..");
        if(Sys.command("fnpp", [Sys.args()[0]]) != 0){
            Sys.println("Process fnpp exited with non zero exit code.");
            Sys.exit(1);
        }
        Sys.println("Compiling..");
        if (Sys.command("fncc", ["out.fn"]) != 0){
            Sys.println("Process fncc exited with non zero exit code.");
            Sys.exit(1);
        }
        if (Sys.command("rm", ["out.fn"]) != 0){
            Sys.println("Process rm exited with non zero exit code.");
            Sys.exit(1);
        }
        Sys.println("Compiled!!");
    }
}