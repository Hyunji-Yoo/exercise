pragma solidity ^0.4.17;



contract CRLManager {
    uint public revokedCount;
    mapping (uint => uint) public revokedList;

    event OnRevoked(uint indexed cert_id, uint indexed when, uint indexed count);

    //
    // @name revoke
    // @desc 인증서 폐기 등록
    // @params
    //  cert_id 인증서 cert_id
    // @out
    //  폐기된 일시 (UTC timestamp)
    function revoke(uint cert_id) public returns (uint) {
        require(cert_id != 0x0);

        if(revokedList[cert_id] == 0x0) {
            revokedList[cert_id] = now;
            revokedCount++;
            
            //
            // generate event
            OnRevoked(cert_id, revokedList[cert_id], revokedCount);
        }
        return revokedList[cert_id];
    }

    // @name status
    // @desc 인증서 상태 조회
    // @params
    //  in cert_ids 조회할 인증서 cert_id 배열
    // @out
    //  인증서 상태 배열 (순서는 cert_ids 와 동일)
    function status(uint[] cert_ids) public view returns (uint[]) {
        require(cert_ids.length > 0);

        uint[] memory ret = new uint[](cert_ids.length);
        for(uint i=0; i<cert_ids.length; i++) {
            ret[i] = revokedList[cert_ids[i]];
        }

        return ret;
    }
}
