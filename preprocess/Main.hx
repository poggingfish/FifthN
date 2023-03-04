import sys.io.File;

class Main{
    public static function Usage(){
        Console.error("fpp <<>file>");
    }
    public static function main(){
        if (Sys.args().length != 1){
            Usage();
            Sys.exit(1);
        }
        var p = File.read(Sys.args()[0]).readAll().toString().split("\n");
        var outstring = "";
        var out = File.write("out.fn");
        for (i in p){
            var t = i.split(" ");
            if (t[0].charAt(0) == "#"){
                t[0] = t[0].substr(1);
                if (t[0] == "include"){
                    outstring += (File.read(t[1]).readAll().toString() + "\n");
                }
            }
            else{
                outstring += (i+"\n");
            }
        }
        outstring = ~/\n/g.replace(outstring," ");
        out.writeString(outstring);
    }
}