// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

///@title KipuBank 
///@author Wendy
///@notice Permite a usuarios depositar y retirar ETH teniendo ciertas consideraciones
contract KipuBank {
    // Variables
	///@notice variable inmutable para almacenar el umbral fijo que se puede retirar por transaccion
	uint256 public immutable i_maxRetiro;
    /// @notice variable inmutable para almacenar el limite global de depositos
    uint256 public immutable i_bankCap;
    /// @notice variable para ir almacenando el total depositado
    uint256 public s_totalDepositos;
    ///@notice variable para llevar registro del nro de depositos 
    uint256 public s_contDepositos;
    ///@notice variable para llevar registro del nro de retiros
    uint256 public s_contRetiros;


    /// @notice Mapping para almacenar el valor depositado por usuario
    mapping(address usuario => uint256 valor) public s_depositos;

    // Eventos
	///@notice evento emitido cuando se realiza un deposito nuevo
    event KipuBank_DepositoRecibido(address usuario, uint256 valor);
    ///@notice evento emitido cuando se realiza un retiro
	event KipuBank_RetiroRealizado(address usuario, uint256 valor);
	
    // Errores
    ///@notice error emitido cuando el valor a tranferir hace que se supere el limite global
    error KipuBank_ExcedeLimiteGlobal(uint256 tatal, uint256 valor);
	///@notice error emitido cuando el valor a retirar supera el fondo disponible
    error KipuBank_FondoInsuficiente(uint256 fondo, uint256 valor);
    ///@notice evento emitido cuando el monto a retirar es superiror al limite permitido por transaccion
    error KipuBank_SuperaLimiteXTransaccion(uint256 limite, uint256 valor);
	///@notice error emitido cuando falla la transferencia
	error KipuBank_TransferenciaFallida(address usuario, uint256 valor);

    ///Modificadores
    ///@notice modificador para validar que no se supere el limite global con el deposito a realizar
    modifier dentroBankCap(uint256 _valor){
        if(s_totalDepositos + _valor > i_bankCap) revert KipuBank_ExcedeLimiteGlobal(s_totalDepositos, _valor);
        _;
    }

    ///@notice modifcador para verifica que los fondos sean suficientes antes de retirar
    modifier suficienteFondo(uint256 _valor){
        if(_valor > s_depositos[msg.sender]) revert KipuBank_FondoInsuficiente(s_depositos[msg.sender], _valor);
        _;
    }
    ///@notice modificador para validar que no se supera el limiite de transaccion
    modifier dentroLimite(uint256 _valor){
        if(_valor > i_maxRetiro) revert KipuBank_SuperaLimiteXTransaccion(i_maxRetiro, _valor);
        _;
    }

    // Funciones
	constructor(uint256 _maxRetiro, uint256 _bankCap){
		i_maxRetiro = _maxRetiro;
        i_bankCap = _bankCap;
	}

    ///@notice función para recibir los depositos
	///@dev esta función debe sumar el valor depositado por cada usuario a lo largo del tiempo
    ///@dev esta función debe sumar el valor depositado al valor total de depositos ya acumulados
    //@dev esta función debe contar la cantidad de deposutos realizados.
    ///@dev esta función debe emitir un evento informando el deposito.
    function depositar() external payable dentroBankCap(msg.value){        //verifico que el deposito no supere el limite global en el modifier
        s_depositos[msg.sender] += msg.value;//actualizo
        s_totalDepositos += msg.value;
    
        s_contDepositos += 1;

        emit KipuBank_DepositoRecibido(msg.sender, msg.value);
    }

    ///@notice función para que el usuario retire fondos de su boveda
	///@param _valor El valor a retirar
    ///@dev el valor a retirar debe estar dentro del limite, ademas debe haber fondo suficiente para poder retirar
    ///@dev esta funcion debe contar la cantidad de retiros realizados
    ///@dev esta función debe emitir un evento informando el retiro
    function retirar(uint256 _valor) external suficienteFondo(_valor) dentroLimite(_valor){         //validadciones en los modifier
        s_depositos[msg.sender] -= _valor; //actualizo el fondo

       _transferirETH(_valor);//tranferencia 

       s_contRetiros += 1;

        emit KipuBank_RetiroRealizado(msg.sender, _valor);

	}

    /// @notice funcion privada tranfiere eth al usuario 
    ///@param _valor valor a tranferir
    ///@dev debe revertir si falla
    function _transferirETH(uint256 _valor) private {
        (bool exito, ) = msg.sender.call{value: _valor}("");
        if (!exito) revert KipuBank_TransferenciaFallida(msg.sender, _valor);
    }

    ///@notice funcion para ver el fondo disponible
    ///@param usuario usuario del que se quiere conocer los fondos disponibles
    ///@dev esta funcion debe devolver el fondo disponible del usuario
    function verFondo(address usuario) external view returns (uint256 valor){
        return s_depositos[usuario];
    }

    ///@notice funcion para ver la cantidad de depositos 
    ///@dev esta funcion debe devolver la cantidad de depositos realizados
    function verContDepositos() external view returns (uint256 valor){
        return s_contDepositos;
    }

    ///@notice funcion para ver la cantidad de retiros 
    ///@dev esta funcion debe devolver la cantidad de retiros realizados
    function verContRetiros() external view returns (uint256 valor){
        return s_contRetiros;
    }
}