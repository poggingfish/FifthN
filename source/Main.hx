import sys.io.File;

class Main{
    public static function Usage(){
        Console.error("Usage: fcc <<>file>");
    }
    public static function parsestr(i: Int, prog: Array<String>): Array<Dynamic>{
        i++;
        var start = true;
        var sbuf = "";
        while(prog[i] != "\""){
            if (start){
                sbuf += prog[i];
                start=false;
            }
            else{
                sbuf += " " + prog[i];
            }
            i++;
        }
        var r = ~/__\$home__/g;
        sbuf = r.replace(sbuf,Sys.getEnv("HOME"));
        return [i, sbuf];
    }
    public static function main(){
        if (Sys.args().length != 1){
            Usage();
            Sys.exit(1);
        }
        var r = ~/\n/g;
        var f = File.read(Sys.args()[0]).readAll().toString();
        f = r.replace(f," ");
        var out = File.write("out.rb");
        var prog = f.split(" ");
        var i = 0;
        var callstack: Array<Int> = new Array<Int>();
        var macros: Map<String,Int> = new Map<String,Int>();
        var val = 0;
        out.writeString("require '~/.fh/lib/stacklib.rb'\n");
        out.writeString("require '~/.fh/lib/tryparse.rb'\n");
        out.writeString("$stack = Stack.new\n");
        out.writeString("a=0\nb=0\n");
        while (i < prog.length){
            var word = prog[i];
            if (word == "macro"){
                var name = prog[++i];
                ++i;
                macros.set(name,i);
                while (prog[i] != "endmac"){
                    i++;
                }
            }
            else if (word == "endmac"){
                i = callstack.pop();
            }
            else if (word == "proc"){
                out.writeString("def " + prog[++i] + "()\n");
            }
            else if (word == "end"){
                out.writeString("end\n");
            }
            else if (word == "."){
                out.writeString("print $stack.Pop()\n");
            }
            else if (word == "+"){
                out.writeString("$stack.Push($stack.Pop()+$stack.Pop())\n");
            }
            else if (word == "-"){
                out.writeString("$stack.Push($stack.Pop()-$stack.Pop())\n");
            }
            else if (word == "*"){
                out.writeString("$stack.Push($stack.Pop()*$stack.Pop())\n");
            }
            else if (word == "/"){
                out.writeString("$stack.Push($stack.Pop()/$stack.Pop())\n");
            }
            else if (word == "\""){
                var _ = parsestr(i,prog);
                i = cast _[0];
                var sbuf: String = cast _[1];
                out.writeString("$stack.Push(\""+sbuf+"\");\n");
            }
            else if (word == "inline\""){
                var _ = parsestr(i,prog);
                var p = ~/\\n/gmi;
                _[1] = p.replace(_[1],"\n");
                i = cast _[0];
                var sbuf: String = cast _[1];
                out.writeString(sbuf);
            }
            else if (word.charAt(0) == "@"){
                out.writeString(word.substr(1) + "()\n");
            }
            else if (word.charAt(0) == "$"){
                callstack.push(i);
                if (macros.get(word.substr(1)) == null){
                    Console.error("Invalid macro " + word.substr(1));
                    Sys.exit(1);
                }
                i = macros.get(word.substr(1))-1;
            }
            else if (word == "nextval"){
                val++;
            }
            else if (word == "prevval"){
                val--;
            }
            else if (word == "getval"){
                out.writeString("val_"+val);
            }
            else if (word == "set"){
                out.writeString("var_"+prog[++i] + " = $stack.Pop()\n");
            }
            else if (word == "get"){
                out.writeString("$stack.Push(var_"+prog[++i]+")\n");
            }
            else if(Std.parseInt(word) != null){
                out.writeString("$stack.Push("+word+")\n");
            }
            i++;
        }
        out.writeString("Main()");
    }
}