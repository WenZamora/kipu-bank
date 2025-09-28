# kipu-bank

## Descripción

KipuBank es un contrato inteligente en Ethereum que permite a los usuarios depositar y retirar tokens nativos (ETH) en una bóveda personal.
El contrato establece un límite global de depósitos definido en el momento del despliegue, y restringe los retiros a un umbral máximo por transacción, garantizando así mayor seguridad y control.
Además, se emiten eventos en cada depósito y retiro exitoso. Y se mantiene un registro del número total de depósitos y retiros realizados por los usuarios.

---

## Instrucciones de despliegue

1. Abrir Remix IDE (https://remix.ethereum.org/) (o el entorno de desarrollo de su preferencia).
2. Crear un archivo `KipuBank.sol` dentro de la carpeta `contracts/` en la pestaña `File explorer` y copiar el código del contrato.
3. En la pestaña `Solidity compiler`, seleccionar la **versión del compilador** `0.8.30` y compilar el contrato.
4. Ir a la pestaña **Deploy & Run Transactions** y configurar:
   - **Environment:** Injected Web3 (para usar MetaMask u otra billetera)
   - **Account:** la cuenta de la testnet Sepolia (u otra testnet configurada en MetaMask).
   - **Contract:** Asegurarse de que esté seleccionado este contrato `KipuBank`
   - **Constructor Arguments:** establecer los valores de los parámetros del constructor, por ejemplo:
     - `_maxRetiro` = `1000000000000000000` (equivalente a 1 ETH) 
     - `_bankCap` = `1000000000000000000` (equivalente a 1 ETH)
5. Hacer clic en **Deploy** y confirmar la transacción en MetaMask..

Una vez confirmada la transaccion, el contrato quedará desplegado en la testnet.

---

## Cómo interactuar con el contrato

Una vez desplegado el contrato, se puede interactuar desde la pestaña `Deploy & run transactions` en Remix.

### Depositar ETH
- En el campo Value, ingresar el monto de ETH que se desea depositar (teniendo en cuenta el saldo disponible en la billetera).
- Hacer clic en **depositar** dentro de la sección `Deployed Contracts`.
- Se envía ETH al contrato y se emite el evento `KipuBank_DepositoRecibido`.

### Consultar fondos
- En la seccion `Deployed Contracts`, en `verFondo(address usuario)` ingresar la dirección del usuario.
- Hacer clic en call.
- Devuelve la cantidad de fondos disponibles para ese usuario.
  
### Consultar cantidad de depósitos
- En la seccion `Deployed Contracts`, hacer clic en `verContDepositos`.
- Devuelve la cantidad total de depósitos realizados.
  
### Retirar ETH
- En la seccion `Deployed Contracts`, en `retirar(uint256 _valor)` la cantidad a retirar.
- Hacer clic en transact y confirmar en la billetera.
- Se transfiere ETH al usuario y se emite el evento `KipuBank_RetiroRealizado`.

### Consultar cantidad de retiros
- Hacer clic en `verContRetiros`.
- Devuelve la cantidad total de retiros realizados.

### Consultar límite global de depósitos
- Hacer clic en `i_bankCap`.
- Devuelve el límite máximo de depósitos definido al momento del despliegue.

### Consultar límite máximo por retiro
- Hacer clic en `i_maxRetiro`
- Devuelve: el valor máximo permitido para retirar en una sola transacción definido al momento del despliegue.
  
