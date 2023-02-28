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
        Sys.command("fnpp", [Sys.args()[0]]);
        Sys.println("Compiling..");
        Sys.command("fncc", ["out.fn"]);
        Sys.command("nekoc", ["out.neko"]);
        Sys.command("rm", ["out.fn"]);
        Sys.println("Compiled!!");
    }
}