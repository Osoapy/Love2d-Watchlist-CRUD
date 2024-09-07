function printMenu()
    print("[1] CRIAR")
    print("[2] LISTAR")
    print("[3] ALTERAR")
    print("[4] DELETAR")
end

function readInput(ehNumero)
    ehNumero = ehNumero or nil
    io.stdin:flush()
    local n
    if (ehNumero) then
        n = io.read("*n")
        lixo = io.read()
    else
        n = io.read() 
    end
    return n
end

function getAtributte(nome, ehFeminino, ehNumero)
    ehFeminino = ehFeminino or nil
    ehNumero = ehNumero or nil
    if (ehFeminino) then
        io.write("Insira a " .. nome .. ": ")
    else
        io.write("Insira o " .. nome .. ": ")
    end
    if (ehNumero) then
        return readInput(1)
    else
        return readInput()
    end
end