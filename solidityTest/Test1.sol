// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract TEST1 {
  /*
    여러분은 선생님입니다. 학생들의 정보를 관리하려고 합니다. 
    학생의 정보는 이름, 번호, 점수, 학점 그리고 듣는 수업들이 포함되어야 합니다.

    번호는 1번부터 시작하여 정보를 기입하는 순으로 순차적으로 증가합니다.

    학점은 점수에 따라 자동으로 계산되어 기입하게 합니다. 90점 이상 A, 80점 이상 B, 70점 이상 C, 60점 이상 D, 나머지는 F 입니다.

    필요한 기능들은 아래와 같습니다.

    * 학생 추가 기능 - 특정 학생의 정보를 추가
    * 학생 조회 기능(1) - 특정 학생의 번호를 입력하면 그 학생 전체 정보를 반환
    * 학생 조회 기능(2) - 특정 학생의 이름을 입력하면 그 학생 전체 정보를 반환
    * 학생 점수 조회 기능 - 특정 학생의 이름을 입력하면 그 학생의 점수를 반환
    * 학생 전체 숫자 조회 기능 - 현재 등록된 학생들의 숫자를 반환
    * 학생 전체 정보 조회 기능 - 현재 등록된 모든 학생들의 정보를 반환
    * 학생들의 전체 평균 점수 계산 기능 - 학생들의 전체 평균 점수를 반환
    * 선생 지도 자격 자가 평가 시스템 - 학생들의 평균 점수가 70점 이상이면 true, 아니면 false를 반환
    * 보충반 조회 기능 - F 학점을 받은 학생들의 숫자와 그 전체 정보를 반환  
    */
    struct Student{
        string name;
        uint numebr;
        uint score;
        string grade;
        string[] lectures;
    }

    Student[] students;
    mapping(uint => Student) mapNumberToStudent;
    mapping(string => Student) mapNameToStudent;

    //학생 추가 기능
    function addStudent(string memory _name, uint _number, uint _score) public {
        string memory _grade;
        string[] memory _lectures;
        uint idx = students.length + 1;

        if(_score>=90) _grade="A";
        else if(_score>=80) _grade="B";
        else if(_score>=70) _grade="C";
        else if(_score>=60) _grade="D";
        else _grade="F";

        Student memory student = Student(_name, idx, _score, _grade, _lectures);
        students.push(student);
        mapNumberToStudent[idx] = student; 
        mapNameToStudent[_name] = student;
    }

    // 학생 조회 기능(1) - 특정 학생의 번호를 입력하면 그 학생 전체 정보를 반환
    function getStudentByNumber(uint _number) public view returns(Student memory){
        return mapNumberToStudent[_number];
    }

    // 학생 조회 기능(2) - 특정 학생의 이름을 입력하면 그 학생 전체 정보를 반환
    function getStudentByName(string memory _name) public view returns(Student memory){
        return mapNameToStudent[_name];
    }

    // 학생 점수 조회 기능 - 특정 학생의 이름을 입력하면 그 학생의 점수를 반환
    function getStudentScore(string memory _name) public view returns(uint){
        return mapNameToStudent[_name].score;
    }

    // 학생 전체 숫자 조회 기능 - 현재 등록된 학생들의 숫자를 반환
    function getStduentCount() public view returns(uint){
        return students.length;
    }

    // 학생 전체 정보 조회 기능 - 현재 등록된 모든 학생들의 정보를 반환
    function getAllStudents() public view returns(Student[] memory){
        return students;
    }

    // 학생들의 전체 평균 점수 계산 기능 - 학생들의 전체 평균 점수를 반환
    function getStudentsAvg() public view returns(uint){
        uint sum;
        for(uint i=0;i<students.length;i++){
            sum+=students[i].score;
        }
        return sum/students.length;
    }

    // 선생 지도 자격 자가 평가 시스템 - 학생들의 평균 점수가 70점 이상이면 true, 아니면 false를 반환
    function isOk() public view returns(bool){
        uint avg = getStudentsAvg();
        if(avg>=70) return true;
        else return false;
    }

    // 보충반 조회 기능 - F 학점을 받은 학생들의 숫자와 그 전체 정보를 반환  
    function getFclass() public view returns(uint, Student[] memory){
        uint cntF;
        for(uint i=0;i<students.length;i++){
            if(keccak256(abi.encodePacked(students[i].grade)) == keccak256(abi.encodePacked("F"))){
                cntF++;
            }
        }

        Student[] memory temp = new Student[](cntF);
        uint idx;
        for(uint i=0;i<students.length;i++){
            if(keccak256(abi.encodePacked(students[i].grade)) == keccak256(abi.encodePacked("F"))){
                temp[idx++]=students[i];
            }
        }

        return (cntF, temp);
    }

    // // S반 조회 기능 - 가장 점수가 높은 학생 4명을 S반으로 설정하는데, 
    // // 이 학생들의 전체 정보를 반환하는 기능 (S반은 4명으로 한정)
    // function getSclass() public view returns(Student[] memory){
    //     //4까지 push, 제일 작은 idx 저장
    //     //제일 작은 idx student와 비교, 크면 갱신, for문 돌려서 idx 갱신
    //     Student[] memory temp = new Student[](4);
    //     uint idx;
    //     uint score=101;
    //     for(uint i=0;i<students.length;i++){
    //         if(i<4){
    //             temp[i]=students[i];
    //             if(score>students[i].score){
    //                 score=students[i].score;
    //                 idx=i;
    //             }
    //         }
    //         else{
    //             Student memory s = temp[idx];
    //             if(s.score<students[i].score){
    //                 temp[idx]=students[i];

    //                 for(uint i=0;i<4;i++){
                        
    //                 }
    //             }
    //         }
    //     }
    // }
}