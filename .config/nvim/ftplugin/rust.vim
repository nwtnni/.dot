setlocal tags+=$RUST_SRC_PATH/rusty-tags.vi
echo "hi"

augroup Rust
    autocmd!
    autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!
augroup end
