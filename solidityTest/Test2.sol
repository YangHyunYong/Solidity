// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Test2{
    /*
    학생 점수관리 프로그램입니다.
    여러분은 한 학급을 맡았습니다.
    학생은 번호, 이름, 점수로 구성되어 있고(구조체)
    가장 점수가 낮은 사람을 집중관리하려고 합니다.

    가장 점수가 낮은 사람의 정보를 보여주는 기능,
    총 점수 합계, 총 점수 평균을 보여주는 기능,
    특정 학생을 반환하는 기능 -> 학생 정보
    가능하다면 학생 전체를 반환하는 기능을 구현하세요. ([] <- array)
    */

    struct Student{
        uint number;
        string name;
        uint score;
    }

    Student[] students;
    mapping(uint=>Student) mapNumbertoStudent;

    function setStudent(uint _number, string memory _name, uint _score) public{
        Student memory student=Student(_number,_name,_score);
        students.push(student);
        mapNumbertoStudent[_number]=student;
    }

    function getLowest() public view returns(Student memory){
        /*
        가장 점수가 낮은 사람의 정보를 보여주는 기능
        */
        require(students.length!=0,"students is empty");
        if(students.length==1) return students[0];
        else{
            Student memory lowest=students[0];
            uint score=students[0].score;
            
            for(uint i=1;i<students.length;i++){
                if(score>students[i].score){
                    lowest=students[i];
                    score=students[i].score;
                }
            }
            return lowest;
        }
    }

    function getScoreSum() public view returns(uint){
        /*
        총 점수 합계
        */
        uint sum;
        for(uint i=0;i<students.length;i++){
            sum+=students[i].score;
        }
        return sum;
    }

    function getScoreAvg() public view returns(uint){
        /*
        총 점수 평균
        */
        require(students.length!=0,"students is empty");
        return getScoreSum()/students.length;
    }

    function getStudent(uint _number) public view returns(Student memory){
        /*
        특정 학생을 반환하는 기능 -> 학생 정보
        */
        return mapNumbertoStudent[_number];
    }

    function getAllStudents() public view returns(Student[] memory){
        /*
        학생 전체를 반환하는 기능
        */
        return students;
    }
}