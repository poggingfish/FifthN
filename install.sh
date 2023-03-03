mkdir -p $HOME/.fh
mkdir -p $HOME/.fh/lib
make
sudo cp bin/fn/Main /usr/bin/fn
sudo cp bin/fncc/Main /usr/bin/fncc
sudo cp bin/fnpp/Main /usr/bin/fnpp
sudo cp lib/* ~/.fh/lib/