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
        var out = File.write("out.neko");
        var prog = f.split(" ");
        var i = 0;
        var callstack: Array<Int> = new Array<Int>();
        var macros: Map<String,Int> = new Map<String,Int>();
        var val = 0;
        out.writeString("var stack = $amake(100);\n");
        out.writeString("var stackptr = 0;\n");
        out.writeString("var a=0;var b=0;\n");
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
                out.writeString("var " + prog[++i] + " = function " + "(stack, stackptr){\n");
            }
            else if (word == "end"){
                out.writeString("}\n");
            }
            else if (word == "endproc"){
                out.writeString("var tmp = $amake(4);tmp[0] = stack;tmp[1]=stackptr;return tmp;}\n");
            }
            else if (word == "."){
                out.writeString("$print(stack[stackptr]);stackptr=stackptr-1;\n");
            }
            else if (word == "+"){
                out.writeString("a = stack[stackptr];stackptr=stackptr-1;b = stack[stackptr];stackptr=stackptr+1;stack[stackptr] = a + b;\n");
            }
            else if (word == "-"){
                out.writeString("a = stack[stackptr];stackptr=stackptr-1;b = stack[stackptr];stackptr=stackptr+1;stack[stackptr] = a - b;\n");
            }
            else if (word == "*"){
                out.writeString("a = stack[stackptr];stackptr=stackptr-1;b = stack[stackptr];stackptr=stackptr+1;stack[stackptr] = a * b;\n");
            }
            else if (word == "/"){
                out.writeString("a = stack[stackptr];stackptr=stackptr-1;b = stack[stackptr];stackptr=stackptr+1;stack[stackptr] = a / b;\n");
            }
            else if (word == "\""){
                var _ = parsestr(i,prog);
                i = cast _[0];
                var sbuf: String = cast _[1];
                out.writeString("stackptr=stackptr+1;stack[stackptr]=\""+sbuf+"\";\n");
            }
            else if (word == "inline\""){
                var _ = parsestr(i,prog);
                i = cast _[0];
                var sbuf: String = cast _[1];
                out.writeString(sbuf);
            }
            else if (word.charAt(0) == "@"){
                out.writeString("a = "+word.substr(1) + "(stack,stackptr);stack = a[0];stackptr=a[1];\n");
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
            else if (word == "init"){
                out.writeString("var var_" + prog[++i] + " = stack[stackptr]; stackptr=stackptr-1;\n");
            }
            else if (word == "set"){
                out.writeString("var_"+prog[++i] + " = stack[stackptr]; stackptr=stackptr-1;\n");
            }
            else if (word == "get"){
                out.writeString("stackptr=stackptr+1; stack[stackptr] = var_" + prog[++i]+";\n");
            }
            else if(Std.parseInt(word) != null){
                out.writeString("stackptr=stackptr+1;stack[stackptr]="+word+";\n");
            }
            i++;
        }
        out.writeString("main(stack,stackptr);");
    }
}