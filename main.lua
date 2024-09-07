-- Importing
require("classes.filme")
require("functions.iof")
require("functions.dao")

-- Global variables
filmFile = "archives/filme.txt"

-- Main
printMenu()
io.write("- ")
local usage = readInput(1)
if (usage == 1) then
    -- [1] CRIAR
    local filme = newFilm()
    filme.setDataLancamento(getAtributte("data de lançamento", 1))
    filme.setProdutora(getAtributte("produtora", 1))
    filme.setDiretor(getAtributte("diretor"))
    filme.setNome(getAtributte("nome"))
    filme.setReceita(getAtributte("receita", 1, 1))
    filme.setOrcamento(getAtributte("orçamento", 0, 1))

    print(filme.getSerialized())
    obj = parse(filme.getSerialized())
    print(obj.nome)
    addInFile(filmFile, filme.getSerialized())
elseif (usage == 2) then
    -- [2] LISTAR
    printFile(filmFile)
elseif (usage == 3) then 
    -- [1] ALTERAR
    local killName = getAtributte("nome do objeto a ser alterado")

    local filme = {}
    filme.dataLancamento = getAtributte("data de lançamento", 1)
    filme.produtora = getAtributte("produtora", 1)
    filme.diretor = getAtributte("diretor")
    filme.nome = getAtributte("nome")
    filme.receita = getAtributte("receita", 1, 1)
    filme.orcamento =getAtributte("orçamento", 0, 1)

    alterFile(filmFile, filme, killName, "filme")
elseif (usage == 4) then
else
end