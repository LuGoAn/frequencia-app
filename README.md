# Frequência — Controle Pessoal de Disciplinas 🎓📱

Um aplicativo Android moderno, minimalista e 100% offline para acompanhamento pessoal de faltas e frequência acadêmica, desenvolvido em Flutter.

Projetado especialmente para estudantes que precisam de precisão no registro de tempos/aulas perdidas, sem complicação, sem cadastros e sem dependência de internet.

---

## ✨ Destaques e Funcionalidades

- **100% Offline & Privado**: Todos os dados ficam salvos unicamente no armazenamento local do seu aparelho. Sem login, sem backend e sem compartilhamento de dados.
- **Cálculo Preciso por Tempos**:
  - Uma aula pode ter **1, 2 ou 3 tempos**.
  - O aplicativo calcula faltas equivalentes exatas: se uma disciplina tem 2 tempos e você perdeu apenas o 1º tempo, é contabilizada **0,5 falta**.
  - Evita acúmulo de erros de arredondamento.
- **Apenas 3 Telas Principais**:
  1. **Tela 1 — Minhas Disciplinas**: Cards espaçosos e limpos com ícone, nome, progresso, frequência e limite de faltas.
  2. **Tela 2 — Detalhes da Disciplina**: Histórico cronológico das ocorrências, status de risco visual e ação direta para registrar faltas.
  3. **Tela 3 — Adicionar / Editar Disciplina**: Cadastro intuitivo com sugestão automática de ícone à medida que você digita.
- **Registro Rápido via Bottom Sheet**: Registre sua falta em menos de 5 segundos ao sair da aula.
- **Sugestão Inteligente de Ícones**: Reconhece automaticamente disciplinas de Ciência da Computação, Engenharia da Computação, Exatas, Humanas e Idiomas (ex: *Banco de Dados* sugere storage, *Inteligência Artificial* sugere robô/cérebro, *Cálculo* sugere funções, *Redes* sugere hub/nuvem).
- **Tema Claro & Escuro Cuidadoso**: Tema claro limpo como padrão e tema escuro projetado especificamente para legibilidade noturna com superfícies de alto contraste e sem inversões artificiais.

---

## 📐 Modelo de Cálculo

O sistema armazena a quantidade exata de tempos perdidos por data e calcula as faltas equivalentes dinamicamente:

$$\text{Faltas Equivalentes} = \frac{\text{Total de Tempos Perdidos}}{\text{Tempos por Encontro}}$$

### Exemplos:
- **Disciplina com 2 tempos/aula** (ex: Limite = 15 faltas):
  - Perdeu 1 tempo = `0,5 falta`
  - Perdeu 2 tempos = `1,0 falta`
- **Disciplina com 3 tempos/aula** (ex: Limite = 15 faltas):
  - Perdeu 1 tempo = `0,33 falta`
  - Perdeu 2 tempos = `0,67 falta`
  - Perdeu 3 tempos = `1,0 falta`

---

## 📥 Como Instalar o APK no Celular

1. Acesse a aba **Releases** deste repositório no seu celular.
2. Baixe o arquivo **`app-release.apk`**.
3. Ao abrir o download no Android, caso o sistema solicite, habilite a permissão de "Instalar apps de fontes desconhecidas" para o seu navegador/gerenciador de arquivos.
4. Conclua a instalação e abra o aplicativo!

---

## 🛠️ Tecnologias Utilizadas

- **Flutter 3.47+** & **Dart**
- **Material 3 Design Tokens** customizados
- **shared_preferences** para armazenamento local leve e confiável
- **intl** para localização de datas em Português do Brasil (`pt_BR`)

---

## 🧪 Testes Automatizados

O projeto conta com suíte de testes unitários e de fluxo para garantir a integridade de todos os cálculos:

```bash
flutter test
```
